require "spec_helper"

describe Upmark, ".convert" do
  subject { Upmark.convert(html) }

  context "<a>" do
    let(:html) { <<-HTML.strip }
<p><a href="http://helvetica.com/" title="art party organic">messenger <strong>bag</strong> skateboard</a></p>
    HTML

    it { should == <<-MD.strip }
[messenger **bag** skateboard](http://helvetica.com/ "art party organic")
    MD
  end

  context "<a> hard" do
    let(:html) { <<-HTML.strip }
<p><a href="http://jobs.latrobe.edu.au/jobDetails.asp?sJobIDs=545808&amp;sKeywords=business">Manager, Business Solutions</a></p>
    HTML

    it { should == <<-MD.strip }
[Manager, Business Solutions](http://jobs.latrobe.edu.au/jobDetails.asp?sJobIDs=545808&amp;sKeywords=business "")
    MD
  end

  context "<img>" do
    let(:html) { <<-HTML.strip }
<img src="http://helvetica.com/image.gif" title="art party organic" alt="messenger bag skateboard" />

    HTML

    it { should == <<-MD.strip }
![messenger bag skateboard](http://helvetica.com/image.gif "art party organic")
    MD
  end

  context "<p>" do
    let(:html) { <<-HTML.strip }
<p>messenger <strong>bag</strong> skateboard</p>

<p>art party<br />
organic</p>
    HTML

    it { should == <<-MD.strip }
messenger **bag** skateboard

art party
organic
    MD
  end

  context "<ul>" do
    let(:html) { <<-HTML.strip }
<ul>
  <li>messenger</li>
  <li><strong>bag</strong></li>
  <li>skateboard</li>
</ul>

<ul>
  <li><p>messenger</p></li>
  <li><p><strong>bag</strong></p></li>
  <li><p>skateboard</p></li>
</ul>
    HTML

    it { should == <<-MD.strip }
* messenger
* **bag**
* skateboard

* messenger

* **bag**

* skateboard
    MD
  end

  context "<ol>" do
    let(:html) { <<-HTML.strip }
<ol>
  <li>messenger</li>
  <li><strong>bag</strong></li>
  <li>skateboard</li>
</ol>

<ol>
  <li><p>messenger</p></li>
  <li><p><strong>bag</strong></p></li>
  <li><p>skateboard</p></li>
</ol>
    HTML

    it { should == <<-MD.strip }
1. messenger
2. **bag**
3. skateboard

1. messenger

2. **bag**

3. skateboard
    MD
  end

  context "<h1>" do
    let(:html) { <<-HTML.strip }
<h1>messenger bag skateboard</h1>
<h2>messenger bag skateboard</h2>
<h3>messenger bag skateboard</h3>
    HTML

    it { should == <<-MD.strip }
# messenger bag skateboard
## messenger bag skateboard
### messenger bag skateboard
    MD
  end

  context "block-level elements" do
    context "<div>" do
      let(:html) { <<-HTML.strip }
<div>messenger <strong>bag</strong> skateboard</div>
<div id="tofu" class="art party">messenger <strong>bag</strong> skateboard</div>
      HTML

      it { should == html }
    end

    context "<table>" do
      let(:html) { <<-HTML.strip }
<table>
  <tr>
    <td>messenger</td>
  </tr>
  <tr>
    <td><strong>bag</strong></td>
  </tr>
  <tr>
    <td>skateboard</td>
  </tr>
</table>
      HTML

      it { should == html }
    end

    context "<pre>" do
      let(:html) { <<-HTML.strip }
<pre>
  <code>
    messenger bag skateboard
  </code>
</pre>
      HTML

      it { should == html }
    end
  end

  context "span-level elements" do
    context "<span>" do
      let(:html) { <<-HTML.strip }
<span>messenger <strong>bag</strong> skateboard</span>
      HTML

      it { should == <<-MD.strip }
<span>messenger **bag** skateboard</span>
      MD
    end
  end
end
