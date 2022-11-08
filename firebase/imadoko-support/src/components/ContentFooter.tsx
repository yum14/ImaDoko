import React from 'react';
import { css, cx } from '@emotion/css';
import { LinkButton, AppleButton } from '../components';

const LINK_WIDTH = 240;
const LINK_HEIGHT = 48;

const styles = {
    container: css`
        padding: 0 16px;
        display: flex;
        justify-content: center;
        align-items: center;
        flex-wrap: wrap;
        gap: 10px 20px;
    `,
    appleButtonContainer: css`
        margin-right: 8px;

        @media screen and (max-width: 480px) {
            margin-right: auto;
            margin-bottom: 12px;
        }        
    `,
    link: css`
        width: ${LINK_WIDTH}px;
        height: ${LINK_HEIGHT}px;

        @media screen and (max-width: 480px) {
            width: 100%;
            /* margin: 0 16px;   */
        }
    `,
}

type LinkType = 'introduction' | 'contact' | 'policy';

type Props = {
    className?: string;
    firstLink: LinkType;
    secondLink: LinkType;
}

const linkInfo = {
    introduction: { text: 'アプリ紹介ページ', path: '/home' },
    contact: { text: 'お問合せはこちら', path: '/contact/' },
    policy: { text: 'プライバシーポリシー', path: '/policy/' },
}

const ContentFooter = (props: Props) => {
    const { className, firstLink, secondLink } = props;

    const containerStyle = cx(styles.container, className)

    return (
        <div className={containerStyle}>
            <div className={styles.appleButtonContainer}>
                <AppleButton />
            </div>
            <LinkButton className={styles.link} text={linkInfo[firstLink].text} path={linkInfo[firstLink].path} />
            <LinkButton className={styles.link} text={linkInfo[secondLink].text} path={linkInfo[secondLink].path} />
        </div>
    )

}

export default ContentFooter;